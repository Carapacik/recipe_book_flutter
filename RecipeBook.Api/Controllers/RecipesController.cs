﻿using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using RecipeBook.Api.Application.Converters;
using RecipeBook.Api.Application.Dtos;
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
        private readonly IRecipeRepository _recipeRepository;
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
            var newRecipe = _recipeService.AddRecipe(new AddRecipeCommand(FormFileAdapter.Create(formFile), recipeData));
            _unitOfWork.Commit();
            return newRecipe.RecipeId;
        }

        [HttpGet("{id:int}")]
        public RecipeDetailDto GetDetailRecipe(int id)
        {
            var recipe = _recipeRepository.GetById(id);
            return recipe.ConvertToRecipeDetailDto();
        }

        [HttpGet("recipe-of-day")]
        public RecipeOfDayDto GetRecipeOfDay()
        {
            var recipe = _recipeRepository.GetRecipeOfDay();
            return recipe.ConvertToRecipeOfDayDto();
        }

        [HttpGet]
        public List<RecipeDto> GetRecipes(
            [FromQuery] int skip,
            [FromQuery] int take,
            [FromQuery] string searchQuery)
        {
            var searchResult = _recipeRepository.Search(skip, take, searchQuery);
            return searchResult.Select(x => x.ConvertToRecipeDto()).ToList();
        }
    }
}