﻿using Microsoft.Extensions.DependencyInjection;
using RecipeBook.Application;
using RecipeBook.Application.Services;
using RecipeBook.Domain.Repositories;
using RecipeBook.Infrastructure.Repositories;

namespace RecipeBook.Infrastructure
{
    public static class ServiceCollectionDependencies
    {
        public static void AddDependencies(this IServiceCollection services)
        {
            services.AddScoped<IRecipeRepository, RecipeRepository>();
            services.AddScoped<IUnitOfWork, UnitOfWork>();
            services.AddScoped<IRecipeService, RecipeService>();
            services.AddScoped<IStaticService, StaticService>();
        }
    }
}