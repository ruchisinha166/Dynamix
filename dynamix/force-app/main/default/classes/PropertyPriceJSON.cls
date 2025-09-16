public class PropertyPriceJSON {
    
    public List<PriceComponent> components;

    public class PriceComponent{
        public String name;
        public String type;
        public String gst;
        public Decimal priceLumpSum;
        public Decimal pricePerSQFT;
    }
}