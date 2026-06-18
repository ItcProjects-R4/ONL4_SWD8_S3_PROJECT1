## 📑 Technical Documentation

### Architecture Pattern

MVC (Model - View - Controller)

### Models

* Recipe Model
* Onboarding Model

### Views

* Application Screens

### Controllers / Services

* ApiService
* AuthService
* FavStorage

### API Integration

The application uses TheMealDB API for fetching recipes:

| Endpoint | Description |
|----------|-------------|
| `search.php?s={query}` | Search for recipes by name |
| `lookup.php?i={id}` | Get full recipe details by ID |
| `filter.php?c={category}` | Filter recipes by category |

### Database Schema

```sql
-- Firebase Authentication
Users: {id, email, displayName, photoURL, createdAt}

-- SharedPreferences (Local Storage)
Favorites: {recipeIds: List<String>}