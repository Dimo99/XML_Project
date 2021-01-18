using System.Collections.Generic;
using System.Xml.Serialization;

namespace XMLScraper
{
    public class Category
    {
        public string CategoryName { get; set; }

        [XmlElement("Anecdote")]
        public List<Anecdote> Anecdodes { get; set; } = new List<Anecdote>();
    }
}
