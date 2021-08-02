﻿using System.Collections.Generic;
using RecipeBook.Api.Application.Entities;

namespace RecipeBook.Api.Application.Repositories
{
    public interface IRecipeRepository
    {
        Recipe GetById(int id);
        void Add(Recipe recipe);
        List<Recipe> Search(int take, int skip, string searchQuery);
    }
}