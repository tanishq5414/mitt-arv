# Postalboxd - Movie Search Application

Postalboxd is a movie search application that allows users to search for movies, view top-rated movies, favorite movies, and sort movies based on different criteria. The application also offers user authentication using Node.js JWT authentication. It utilizes the TMDB API to fetch movie data.

## Features

### Home Page & Infinite Scrolling

- Displays a list of top-rated movies.
- Shows movie name, poster, year, and rating.
- Implements lazy loading to load additional movies as users scroll down.

### Search Page & Sort/Filter

- Provides a search bar for users to search for movies by titles.
- Offers options to sort movies by year, popularity, and rating.

### Movie Details

- Detailed view of a selected movie, including information such as cast, plot, and more.
- Users can mark movies as favorites from this screen.

### Favourites

- Allows users to mark movies as favorites.
- If the user is logged in, favorites are stored in a MongoDB cluster.
- If the user is logged out, favorites are stored locally using shared preferences.

### User Authentication

- Implements user login and registration functionality using JWT token authentication.
- Backend written in Node.js and user data stored in MongoDB.
- JWT token is valid for one day, and users are automatically logged out after token expiry.
- Provides validations for usernames and email addresses.



## Implementation Details

- Flutter Riverpod is used for state management.
- The `dio` package is utilized for API calls and handling responses.
- `shared_preferences` is used for persisting user authentication state.
- MongoDB with Node.js is used to store and fetch user details.

## Future Enhancements

- Implement a more detailed view of individual movies.
- Integrate advanced search filters.
- Add settings and user profile pages.
- Implement an API to search for movie trailers and display them.

## Conclusion

Postalboxd provides a user-friendly interface for searching, browsing, and listing movies. Its features like top-rated lists, sorting, favorites, and user authentication enhance the user experience. The application adheres to best coding practices, resulting in a seamless user experience.

For more details, you can also check out the [GitHub repository](https://github.com/tanishq5414/mitt-arv) and the backend deployed on Vercel: [Backend URL](https://mitt-arv.vercel.app/api).

