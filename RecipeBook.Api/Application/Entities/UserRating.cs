namespace RecipeBook.Api.Application.Entities
{
    public class UserRating
    {
        public int RecipeId { get; }
        public int UserId { get; }
        public bool InFavorite { get; set; }
        public bool IsLiked { get; set; }
    }
}