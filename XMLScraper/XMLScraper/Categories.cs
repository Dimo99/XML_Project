using System.Collections.Generic;
using System.Xml.Serialization;

namespace XMLScraper
{
    public class Categories
    {
        [XmlElement("Category")]
        public List<Category> CategoriesList { get; set; }
    }
}
