﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using RecipeBook.Api.Converters;
using RecipeBook.Api.Dtos;
using RecipeBook.Application;
using RecipeBook.Application.Entities;
using RecipeBook.Application.Services;
using RecipeBook.Domain.Entities;
using RecipeBook.Domain.Repositories;

namespace RecipeBook.Api.Controllers
{
    [ApiController]
    [Route( "api/[controller]" )]
    public class RecipesController : ControllerBase
    {
        private readonly IRecipeRepository _recipeRepository;
        private readonly IRecipeService _recipeService;
        private readonly IUnitOfWork _unitOfWork;
        private readonly UserBuilder _userBuilder;

        public RecipesController(
            IRecipeRepository recipeRepository,
            IUnitOfWork unitOfWork,
            IRecipeService recipeService,
            UserBuilder userBuilder )
        {
            _recipeRepository = recipeRepository;
            _unitOfWork = unitOfWork;
            _recipeService = recipeService;
            _userBuilder = userBuilder;
        }

        [HttpPost]
        [Authorize]
        [DisableRequestSizeLimit]
        public int AddRecipe()
        {
            string username = User.Identity?.Name;
            Recipe newRecipe = _recipeService.AddRecipe( RecipeCommandParser( Request.Form, username ) );
            _unitOfWork.Commit();
            return newRecipe.RecipeId;
        }

        [HttpDelete( "{id:int}/delete" )]
        [Authorize]
        public void DeleteRecipe( int id )
        {
            string username = User.Identity?.Name;
            _recipeService.DeleteRecipe( id, username );
            _unitOfWork.Commit();
        }

        [HttpPatch( "{id:int}/edit" )]
        [Authorize]
        [DisableRequestSizeLimit]
        public int EditRecipe( int id )
        {
            string username = User.Identity?.Name;
            Recipe newRecipe = _recipeService.EditRecipe( RecipeCommandParser( Request.Form, username, id ) );
            _unitOfWork.Commit();

            return newRecipe.RecipeId;
        }

        [HttpGet( "{id:int}" )]
        public RecipeDetailDto GetDetailRecipe( int id )
        {
            Recipe recipe = _recipeRepository.GetById( id );
            if ( recipe == null ) throw new ValidationException( "Recipe does not exist" );
            return _userBuilder.AddUserNameToRecipeDetail( recipe );
        }

        [HttpGet( "recipe-of-day" )]
        public RecipeOfDayDto GetRecipeOfDay()
        {
            Recipe recipe = _recipeRepository.GetRecipeOfDay();
            if ( recipe == null ) throw new ValidationException( "Recipe does not exist" );

            return _userBuilder.AddUserNameToRecipeOfDay( recipe );
        }

        [HttpGet( "favorite" )]
        [Authorize]
        public List<RecipeDto> GetFavoriteRecipes(
            [FromQuery] int skip,
            [FromQuery] int take )
        {
            string username = User.Identity?.Name;
            IReadOnlyList<Recipe> searchResult = _recipeRepository.GetFavoriteRecipes( skip, take, username );

            return _userBuilder.AddUserNameToRecipes( searchResult );
        }

        [HttpGet]
        public List<RecipeDto> GetAllRecipes(
            [FromQuery] int skip,
            [FromQuery] int take,
            [FromQuery] string searchQuery )
        {
            IReadOnlyList<Recipe> searchResult = _recipeRepository.Search( skip, take, searchQuery );

            return _userBuilder.AddUserNameToRecipes( searchResult );
        }

        private static RecipeCommand RecipeCommandParser( IFormCollection formCollection, string username, int id = 0 )
        {
            RecipeCommandDto recipeData = JsonConvert.DeserializeObject<RecipeCommandDto>( formCollection[ "data" ] );
            if ( recipeData == null ) throw new ArgumentException( "Data is null" );
            recipeData.RecipeId = id;
            IFormFile formFile = null;
            if ( formCollection.Files.Count > 0 ) formFile = formCollection.Files[ 0 ];

            return recipeData.ConvertToRecipeCommand( FormFileAdapter.Create( formFile ), username );
        }
    }
}
