/*
Author: Peter Jamieson
Description: This reads an xml file and stores it into an object of movies.
	There is a print out function to check if it's working.  I do no 
	error checking on the correctness of the xml file!!!
*/
/* 
 Braden Campbell: Designed the Views_db and Views classes. Designed the print_views_db, create_views_db, and get_titles methods. 
                  borrowed the print_guess_xml from the "PICKER" solution off of Niihka. 
*/
/*-------------------------------------------------
GLOBALS
-------------------------------------------------*/
XML user_xml;   // xml container
Users user_db; // the class top containing all the movies

Views_db views_db;   //declaring the database that stores the total views for each movie title
XML guess_xml;      //declaring the XML that the movie predictions will be written to

void setup()
{
	String[] guesses = new String[4];  //declaring the string array that will store the titles of the predicted movies
        read_user_db("benchmark1.xml");    
	print_user_db(user_db);
        create_views_db(user_db);                     //declaring create_views_db method
        print_views_db(views_db);                    //declaring print_views_db method
        guesses = get_titles(views_db);             //declaring get_titles method
        String guess_xml_name = "guess_xml.xml";   //setting name for output xml file
        print_guess_xml(guesses, guess_xml_name); //declaring print_guess_xml
}
//this method goes through the user database object and totals up the number of views for each movie and stores them within a "Views_db" object
void create_views_db(Users user_db){  
  int movie_views;                  //counter for the movie views
  String title;                    //title of movie being evaluated
  views_db = new Views_db(316);   //declaring a new movie database object of 316 titles, normally this would not be a specific length, 
                                 //but for some reason not every user evaluated the same number of movies, so the last 20 movies in the database had to be cut off. 
  
  for(int j = 0; j < 316; j++){                               //loop through the user database to get the total number of views for each title
       title = user_db.user_list[1].user_movies[j].title;    //get the title of the current movie being evaluated
       movie_views = 0;                                     //reset the view counter after evaluating each movie
       for (int i = 0; i < user_db.user_list.length; i++){ //loop through the user database and get the number of views for each title for each user
              movie_views += user_db.user_list[i].user_movies[j].viewed; //add the number of times the current user watched the current movie to the total views for that title
       }
       views_db.add_movie(j, movie_views, title);          //save the total views and title of the current title to the views database
  }
}
   //this method prints out the contents of the views database, so I could evaluate it.
void print_views_db(Views_db views_db){   
  for(int j = 0; j < views_db.newViews.length; j++){          //loop through the views database
    println("M"+j+": "+ views_db.newViews[j].title + "  Views: " + views_db.newViews[j].views); //print out each title with its total number of views
  }
}
//this method finds the top 4 titles with the most views, and stores their titles in a string array
String[] get_titles(Views_db views_db){ 
    String guess1 = "", guess2 = "", guess3 = "", guess4 = ""; //declaring and initializing the array of titles
    int views1 = 0, views2 = 0, views3 = 0, views4 = 0;       //variables containing the top 4 total views 
    for(int j = 0; j < 316; j++){                            //loop throught the views database 
       if(views_db.newViews[j].views > 100){}               //this statement was added because there were a couple of movies with ridiculous amounts of views.
       else if(views_db.newViews[j].views > views1){       //if the current title being checked has more views than one of the current top 4, save its
          if(views1 > views2){                            //title into the array, and set its total views to one of the top 4 values. kick out the lowest value.
            guess2 = guess1;
            views2 = views1;
          }
          else if(views1 > views4){      //these nested if statments are to ensure that the value is kept if it is not the smallest. It is not 100% fullproof, but good enough. 
            views4 = views1;
            guess4 = guess1;
          }
          else if(views1 > views3){
             views3 = views1;
             guess3 = guess1; 
          }
          guess1 = views_db.newViews[j].title;            
          views1 = views_db.newViews[j].views;
       }
       else if(views_db.newViews[j].views > views2){
          if(views2 > views3){
            guess3 = guess2;
            views3 = views2;
          }
          else if(views2 > views4){
            views4 = views2;
            guess4 = guess2;
          }
          else if(views2 > views1){
             views1 = views2;
             guess1 = guess2; 
          }
          guess2 = views_db.newViews[j].title;
          views2 = views_db.newViews[j].views;
       }
       else if(views_db.newViews[j].views > views3){
           if(views3 > views2){
            guess2 = guess3;
            views2 = views3;
          }
          else if(views3 > views4){
            views4 = views3;
            guess4 = guess3;
          }
          else if(views3 > views1){
             views1 = views3;
             guess1 = guess3; 
          }
          guess3 = views_db.newViews[j].title;
          views3 = views_db.newViews[j].views;
       } 
       else if(views_db.newViews[j].views > views4){
          if(views4 > views2){
            guess2 = guess4;
            views2 = views4;
          }
          else if(views4 > views3){
            views3 = views4;
            guess3 = guess4;
          }
          else if(views4 > views1){
             views1 = views4;
             guess1 = guess4; 
          }
          guess4 = views_db.newViews[j].title;
          views4 = views_db.newViews[j].views;
       } 
      
    }
    
    String[] guesses = {guess1, guess2, guess3, guess4}; //create the string array containing the titles of the top 4 most viewed titles.
    println(guesses[0]+ " "+guesses[1]+" "+guesses[2]+"  "+guesses[3]);     //print out the string array to see what it contains.
    return guesses;                                    // return the string array containing the titles of the top 4 titles so they can be printed to the output xml file.
}
//this method prints the top 4 movies into each user in the xml file. I predicted the same 4 movies for each user. 
void print_guess_xml(String[] guesses, String guess_xml_name){ //predicting the same movies for everyone based on the 4 most viewed is basically the same as the "popular on Netflix" section.
   guess_xml = loadXML(guess_xml_name);
                                                        //This code was taken from PICKER, not sure whose code it is
  for(int j = 0; j < user_db.user_list.length; j++){    //loop through the usernames to print them to the output xml file
      XML newGuess = guess_xml.addChild("guess");       //adds a new guess to the xml file. Each guess is 4 movies for one user.
      XML name = newGuess.addChild("id");               //add username to xml file
      name.setContent(user_db.user_list[j].user_name);  //pull username from database and print it to output xml file
      XML title1 = newGuess.addChild("title");          //add new title
      title1.setContent(guesses[0]);                    //pull the first title from the string array of the top 4 titles
      XML title2 = newGuess.addChild("title");          //add new title 
      title2.setContent(guesses[1]);                    //pull second title
      XML title3 = newGuess.addChild("title");          //....
      title3.setContent(guesses[2]);                    //.....
      XML title4 = newGuess.addChild("title");          //.......
      title4.setContent(guesses[3]);                    //..........
  }
      saveXML(guess_xml, guess_xml_name);               //save xml file
}





/*-------------------------------------------------
Read User Database
Initializes data structure that contains all the
movies
-------------------------------------------------*/
void read_user_db(String user_db_name)
{
	user_xml = loadXML(user_db_name);
	XML[] user = user_xml.getChildren("user");
	
	/* Initialize the movie data base */
	user_db = new Users(user.length);

	/* Get each movie entry */
	for (int i = 0; i < user.length; i++) 
	{
		XML[] item1 = user[i].getChildren("id");
		String id = item1[0].getContent();

		XML[] items = user[i].getChildren("genre");
		String[] genres = new String[items.length];
		for (int j = 0; j < items.length; j++)
		{
			 genres[j] = items[j].getContent();
		}

		items = user[i].getChildren("actor");
		String[] actors = new String[items.length];
		for (int j = 0; j < items.length; j++)
		{
			 actors[j] = items[j].getContent();
		}
		
		items = user[i].getChildren("director");
		String[] directors = new String[items.length];
		for (int j = 0; j < items.length; j++)
		{
			 directors[j] = items[j].getContent();
		}

		/* get the number of movies */
		items = user[i].getChildren("movie");

		/* add the new user */
		user_db.add_new_user(i, id, genres, actors, directors, items.length);

 		for (int j = 0; j < items.length; j++)
		{
			XML [] inner_item = items[j].getChildren("title");
			String title = inner_item[0].getContent();

			inner_item = items[j].getChildren("rating");
			int rating = parseInt(inner_item[0].getContent());
			
			inner_item = items[j].getChildren("viewed");
			int viewed = parseInt(inner_item[0].getContent());

			

			user_db.add_new_movie(i, j, title, rating, viewed);
		}
	}
}

/*-------------------------------------------------
Print/Check Movie Database
Prints out the data in the movie database
-------------------------------------------------*/
void print_user_db(Users user_db)
{
        println ("There are: " + user_db.user_list.length + " users");  	
        
        for (int i = 0; i < user_db.user_list.length; i++)
	{
		println("U:"+user_db.user_list[i].user_name);

		for (int j = 0; j < user_db.user_list[i].genres.length; j++)
		{
			print("G["+j+"]:"+user_db.user_list[i].genres[j]+" ");
		}
		for (int j = 0; j < user_db.user_list[i].actors.length; j++)
		{
			print("A["+j+"]:"+user_db.user_list[i].actors[j]+" ");
		}
		for (int j = 0; j < user_db.user_list[i].directors.length; j++)
		{
			print("D["+j+"]:"+user_db.user_list[i].directors[j]+" ");
		}
		println("");
		for (int j = 0; j < user_db.user_list[i].user_movies.length; j++)
		{
			println("M["+j+"]:"+user_db.user_list[i].user_movies[j].title + " R:" + user_db.user_list[i].user_movies[j].rating  + " V:" + user_db.user_list[i].user_movies[j].viewed);
		}
	}
}

/*-------------------------------------------------
  Class for all users
-------------------------------------------------*/
class Users
{
	User[] user_list; 
	
	Users(int num_users)
	{
		this.user_list = new User[num_users];
	}

	void add_new_user(int id, String sid, String[] genres, String[] actors, String[] directors, int num_movies)
	{
		this.user_list[id] = new User(sid, genres, actors, directors, num_movies);
	}

	void add_new_movie(int user_id, int movie_id, String title, int rating, int viewed)
	{
		this.user_list[user_id].add_new_movie(movie_id, title, rating, viewed);
	}

}

/*-------------------------------------------------
  Class for each user
-------------------------------------------------*/
class User
{
	String user_name;
	String [] genres;
	String [] actors;
	String [] directors;
	Movie_user [] user_movies;

	User(String user_name, String [] genres, String [] actors, String [] directors, int num_movies)
	{
		this.user_name = user_name;
		this.genres = genres;
		this.actors = actors;
		this.directors = directors;
		this.user_movies = new Movie_user[num_movies];
	}

	void add_new_movie(int id, String title, int rating, int viewed)
	{
		this.user_movies[id] = new Movie_user(title, rating, viewed);
	}
}
	

/*-------------------------------------------------
  Class for Movie Entry for User
-------------------------------------------------*/
class Movie_user
{
	String title;
	int rating;
	int viewed;
	

	Movie_user(String title, int rating, int viewed)
	{
		this.title = title;
		this.rating = rating;
		this.viewed = viewed;
		
	}

}

 class Views_db{    //this class object stores multiple Views objecs into an array. 
   Views[] newViews;  
  
   Views_db(int num_movies){  //when a database is declared, its length is set.
           this.newViews = new Views[num_movies]; 
   } 
   
   void add_movie(int id, int views, String title){   //this function adds a new title with its total views ot the array
           this.newViews[id] = new Views(title, views); 
   }
}

class Views {                 //This class object stores a movies title with its total number of views 
     String title;
     int views;
    
     Views(String title, int views){
         this.title = title;
         this.views = views; 
     }
}
