using HtmlAgilityPack;
using ScrapySharp.Network;
using System;
using System.Linq;
using System.Collections.Concurrent;
using System.IO;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace XMLScraper
{
    class Program
    {
        private const string vestiUrl = "https://www.vesti.bg/vicove";
        private static int counter = 0;

        static void Main()
        {
            WebPage anecdodesPage = new ScrapingBrowser().NavigateToPage(new Uri(vestiUrl));
            HtmlNodeCollection categoriesLinks = anecdodesPage.Html.SelectNodes("//ul[@class='vicove-nav']/li/a");
            ConcurrentBag<Category> categories = new ConcurrentBag<Category>();

            Parallel.ForEach(categoriesLinks, (categoryLink) =>
            {
                Category category = GetCategory(categoryLink);
                categories.Add(category);
            });

            Categories categoriesObject = new Categories() { CategoriesList = categories.ToList() };

            XmlSerializer serializer = new XmlSerializer(typeof(Categories));

            using (TextWriter writer = new StreamWriter("anecdotes.xml"))
            {
                serializer.Serialize(writer, categoriesObject);
            }

        }

        private static Category GetCategory(HtmlNode categoryLink)
        {
            string href = categoryLink.GetAttributeValue("href", null);
            string categoryName = categoryLink.InnerText;

            Category category = new Category();
            category.CategoryName = categoryName;


            // Doing binary search to find the number of pages
            // as the idea was to proccess each page also on paralell as the categories
            // but emperical testing showed that non paralell scraping is faster
            int left = 0;
            int right = 1000;

            int found = 0;

            while (left <= right)
            {
                int mid = (left + right) / 2;
                WebPage webPage = new ScrapingBrowser().NavigateToPage(new Uri($"{href}/{mid}"));
                HtmlNode nextBtn = webPage.Html.SelectSingleNode("//a[text()='Следващи' and @class='btn btn-white']");

                if (nextBtn == null)
                {
                    found = mid;
                    right = mid - 1;
                }
                else
                {
                    left = mid + 1;
                }
            }

            for (int i = 1; i <= found; i++)
            {
                AddAnecdodesToCategoryFromPage($"{href}/{i}", category);
            }

            return category;
        }

        private static void AddAnecdodesToCategoryFromPage(string href, Category category)
        {
            Console.WriteLine(href);
            WebPage currentCategoryPage;

            try
            {
                currentCategoryPage = new ScrapingBrowser().NavigateToPage(new Uri(href));
            }
            catch (Exception)
            {
                // non deterministicaly requests fail retry is maybe a better option
                // An error occurred while sending the request. Unable to read data from the transport connection: An existing connection was forcibly closed by the remote host..
                return;
            }

            HtmlNodeCollection anecdoteDivs = currentCategoryPage.Html.SelectNodes("//ul[@class='anecdote-list category']/li/div");

            foreach (var anecdoteHtml in anecdoteDivs)
            {
                Anecdote anecdote = GetAnecdote(anecdoteHtml);
                if (anecdote != null)
                {
                    counter++;
                    anecdote.Id = counter;
                    category.Anecdodes.Add(anecdote);
                }
            }
        }

        private static Anecdote GetAnecdote(HtmlNode anecdoteHtml)
        {
            HtmlNode workingNode = anecdoteHtml;
            Anecdote anecdote = new Anecdote();
            var paragraph = anecdoteHtml.SelectSingleNode("p");
            if (paragraph.SelectSingleNode(".//span[@class='learnMoreButton']") != null)
            {
                string url = paragraph.SelectSingleNode(".//span[@class='learnMoreButton']/a").GetAttributeValue("href", null);

                WebPage anecdotePage;
                try
                {
                    anecdotePage = new ScrapingBrowser().NavigateToPage(new Uri(url));
                }
                catch (Exception)
                {
                    // continue because some urls are invalid and return 404
                    return null;
                }

                workingNode = anecdotePage.Html.SelectSingleNode("//div[@class='anecdote-text']");
            }

            // skip as there are some invalid data
            if (workingNode == null)
            {
                return null;
            }

            anecdote.Content = workingNode.SelectSingleNode(".//p").InnerText.Trim();

            int.TryParse(workingNode.SelectSingleNode(".//span[@class='icon like']").InnerText, out int numberOfLikes);
            anecdote.NumberOfLikes = numberOfLikes;

            int.TryParse(
                workingNode.SelectSingleNode(".//span[@class='icon love']").InnerText, out int numberOfHearts);
            anecdote.NumberOfHearts = numberOfHearts;

            int.TryParse(
                workingNode.SelectSingleNode(".//span[@class='icon happy']").InnerText, out int numberOfHaha);
            anecdote.NumberOfHaha = numberOfHaha;

            int.TryParse(
                workingNode.SelectSingleNode(".//span[@class='icon wow']").InnerText, out int numberOfWow);
            anecdote.NumberOfWow = numberOfWow;

            int.TryParse(
                workingNode.SelectSingleNode(".//span[@class='icon cry']").InnerText, out int numberOfSad);
            anecdote.NumberOfSad = numberOfSad;

            HtmlNode iframeNode = workingNode
                .SelectSingleNode(".//div[@class='anecdote-share']/center/iframe");
            string src = iframeNode.GetAttributeValue("src", null);

            WebPage iframePage;
            try
            {
                iframePage = new ScrapingBrowser().NavigateToPage(new Uri(src));
            }
            catch (Exception)
            {
                //non deterministically some requests fail retry is maybe a better option in such case
                //  An error occurred while sending the request. Unable to read data from the transport connection: An existing connection was forcibly closed by the remote host..
                return anecdote;
            }
            HtmlNode element = iframePage.Html.SelectSingleNode("//span[text()='Share']");

            // again strange problem with unicode urls and facebook iframes so just skip facebook shares
            if (element != null)
            {
                int.TryParse(
                    iframePage.Html.SelectSingleNode("//span[text()='Share']").NextSibling.InnerText, out int numberOfFacebookShares);
                anecdote.NumberOfFacebookShares = numberOfFacebookShares;
            }

            return anecdote;
        }
    }
}
