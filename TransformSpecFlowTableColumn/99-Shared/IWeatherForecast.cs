namespace TransformSpecFlowTableColumn.Shared
{
    public interface IWeatherForecast
    {
        public DateTime Date { get; set; }

        public int LocationId { get; set; }

        public int Temperature { get; set; }
    }
}
