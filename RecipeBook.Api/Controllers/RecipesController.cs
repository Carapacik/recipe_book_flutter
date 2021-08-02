﻿using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using RecipeBook.Api.Application.Converters;
using RecipeBook.Api.Application.Dtos;
using RecipeBook.Api.Application.Entities;
using RecipeBook.Api.Application.Repositories;
using RecipeBook.Api.Application.Services;
using RecipeBook.Api.Application.Services.Entities;
using RecipeBook.Api.Infrastructure;

namespace RecipeBook.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RecipesController : ControllerBase
    {
        private readonly IRecipeRepository _recipeRepository; // для получения данных
        private readonly IRecipeService _recipeService;
        private readonly IUnitOfWork _unitOfWork;

        public RecipesController(IRecipeRepository recipeRepository, IUnitOfWork unitOfWork, IRecipeService recipeService)
        {
            _recipeRepository = recipeRepository;
            _unitOfWork = unitOfWork;
            _recipeService = recipeService;
        }

        [HttpPost]
        [DisableRequestSizeLimit]
        public int AddRecipe()
        {
            var recipeData = JsonConvert.DeserializeObject<AddRecipeCommandDto>(Request.Form["recipe"]);
            var formFile = Request.Form.Files[0];
            var addRecipeCommand = new AddRecipeCommand(FormFileAdapter.Create(formFile), recipeData);
            var newRecipe = _recipeService.AddRecipe(addRecipeCommand);

            _unitOfWork.Commit();
            return newRecipe.RecipeId;
        }
        
        [HttpGet]
        public List<Recipe> GetRecipes(
            [FromQuery]int take, 
            [FromQuery]int skip, 
            [FromQuery]string searchQuery)
        {

            var searchResult = _recipeRepository.Search(take, skip, searchQuery);

            return searchResult;
        }

        [HttpGet("recipe-of-day")]
        public RecipeOfDayDto GetRecipeOfDay()
        {
            return new()
            {
                RecipeId = 1,
                Title = "Тыквенный супчик на кокосовом молоке",
                Description = "Если у вас осталась тыква, и вы не знаете что с ней сделать, то это решение для вас!",
                ImageUrl = "assets/images/recipe_of_day.png",
                CookingTimeInMinutes = 35,
                LikesCount = 365,
                Username = "@glazest"
            };
        }
    }
}