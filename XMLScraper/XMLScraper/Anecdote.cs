using System.Xml.Serialization;

namespace XMLScraper
{
    public class Anecdote
    {
        [XmlAttribute("id")]
        public int Id { get; set; }

        public string Content { get; set; }

        public int NumberOfLikes { get; set; }

        public int NumberOfHearts { get; set; }

        public int NumberOfHaha { get; set; }

        public int NumberOfWow { get; set; }

        public int NumberOfSad { get; set; }

        public int NumberOfFacebookShares { get; set; }
    }
}
