using System;
using System.Text.Json;
using Avalonia;
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Markup.Xaml;
using GraphQL;
using GraphQL.Client.Http;
using GraphQL.Client.Serializer.Newtonsoft;

namespace EmpireBuilder
{
    public class MainWindow : Window
    {
        public string ActiveQuery { get; set; }
        
        public MainWindow()
        {
            InitializeComponent();
#if DEBUG
            this.AttachDevTools();
#endif

            ActiveQuery = @"
                {
                    logistics_Railraod(where: {name: {_eq: ""Amtrak""}}) {
                        name
                }}";

            this.FindControl<TextBox>("RailroadQuery").Text = ActiveQuery;
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }

        private async void Button_Click(object sender, RoutedEventArgs e)
        {
            var responseText = this.FindControl<TextBlock>("RailroadResponse");
            
            using var graphQLClient = new GraphQLHttpClient("http://localhost:8080/v1/graphql", new NewtonsoftJsonSerializer());
            
            var railraodsRequest = new GraphQLRequest {
                Query = this.FindControl<TextBox>("RailroadQuery").Text
            };

            var graphQlResponse = await graphQLClient.SendQueryAsync<ResponseType>(railraodsRequest);
            
            Console.WriteLine(JsonSerializer.Serialize(graphQlResponse, new JsonSerializerOptions { WriteIndented = true }));
            
            responseText.Text = graphQlResponse.Data.ToString();
        }
    }
    
    public class ResponseType
    {
        public RailroadType Railroad { get; set; }
    }

    public class RailroadType
    {
        public string Name { get; set; }
    }
}
