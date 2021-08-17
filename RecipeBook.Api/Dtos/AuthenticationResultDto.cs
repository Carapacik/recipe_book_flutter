﻿namespace RecipeBook.Api.Dtos
{
    public class AuthenticationResultDto
    {
        public AuthenticationResultDto( bool result, string error )
        {
            Result = result;
            Error = error;
        }

        public bool Result { get; }
        public string Error { get; }
    }
}
