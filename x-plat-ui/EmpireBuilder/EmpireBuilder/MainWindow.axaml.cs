using System;
using Avalonia;
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Markup.Xaml;
using GraphQL;
using GraphQL.Types;
using SharpDX.Direct3D11;
using GraphQL.Client;
using GraphQL.Client.Http;
using GraphQL.Client.Serializer.Newtonsoft;

namespace EmpireBuilder
{
    public class Railroad
    {
        public string Name { get; set; }
        public string ServiceArea { get; set; }
        public string Uri { get; set; }
        public string WikipediaUri { get; set; }
        public string MapLink { get; set; }
        public string HqCity { get; set; }
        public string History { get; set; }
        public Guid Id { get; set; }
    }
    
    public class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
#if DEBUG
            this.AttachDevTools();
#endif
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            var graphQLClient = new GraphQLHttpClient("http://localhost:8080/v1/graphql", new NewtonsoftJsonSerializer());
            var railraodsRequest = new GraphQLRequest {
                Query = @"
                {
                  logistics_Railraod {
                    name
                    hqCity
                    mapLink
                    serviceArea
                  }
                }"
            };

            var responseText = this.FindControl<TextBox>("RailroadResponse");
            responseText.Text = "test";
        }
    }
}
