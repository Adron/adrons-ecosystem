using System;
using System.Collections.Generic;

namespace GraphQL.Client.Example
{
    public class PersonAndFilmsResponse
    {
        public PersonContent Person { get; set; }

        public class PersonContent
        {
            public string Name { get; set; }

            public FilmConnectionContent FilmConnection { get; set; }

            public class FilmConnectionContent
            {
                public List<FilmContent> Films { get; set; }

                public class FilmContent
                {
                    public string Title { get; set; }
                }
            }
        }
    }

    public class VerifierDataLogResponse
    {
        public VerifierDataLogContent VerifierDataLog { get; set; }

        public class VerifierDataLogContent
        {
            public Guid Id { get; set; }
            public DateTime Stamp { get; set; }
            public string Details { get; set; }
        }
    }
}
