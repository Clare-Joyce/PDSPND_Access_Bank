import time
import pandas as pd
import numpy as np

CITY_DATA = { 'chicago': 'chicago.csv',
              'new york city': 'new_york_city.csv',
              'washington': 'washington.csv' }

def get_filters():
    """
    Asks user to specify a city, month, and day to analyze.

    Returns:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    """
    print('Hello! Let\'s explore some US bikeshare data!')
    # TO DO: get user input for city (chicago, new york city, washington). HINT: Use a while loop to handle invalid inputs
    while True:
        city = input("Enter the name of the city to explore: ").lower().strip()
        if city in list(CITY_DATA.keys()):
            break
        else:
            print("City must be either Chicago, New York City or Washington.")

    # TO DO: get user input for month (all, january, february, ... , june)
    months_list = ['all', 'january', 'february', 'march', 'april', 'may', 'june']
    while True:
        month = input("Enter the name of the month to explore: ").lower().strip()
        if month in months_list:
            break
        else:
            print("The month can either be 'all' or any month from january to june.")


    # TO DO: get user input for day of week (all, monday, tuesday, ... sunday)
    days = ['all', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
    while True:
        day = input("Enter the name of the day to explore: ").lower().strip()
        if day in days:
            break
        else:
            print("The day can either be 'all' or any day from monday to sunday.")


    print('-'*40)
    return city, month, day


def load_data(city, month, day):
    """
    Loads data for the specified city and filters by month and day if applicable.

    Args:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    Returns:
        df - Pandas DataFrame containing city data filtered by month and day
    """
    # load data file into a dataframe
    try:
        df = pd.read_csv(CITY_DATA.get(city))
    except FileNotFoundError:
        city = city.replace(' ', '_')
        df = pd.read_csv(CITY_DATA.get(city))
    except:
        print("Something went wrong, please restart.")

    # convert the Start Time column to datetime
    df['Start Time'] = pd.to_datetime(df['Start Time'])
    df['End Time'] = pd.to_datetime(df['End Time'])

    # extract month and day of week from Start Time to create new columns
    df['month'] = df['Start Time'].dt.month
    df['day_of_week'] = df['Start Time'].dt.day_name()

    # filter by month if applicable
    if month != 'all':
        # use the index of the months list to get the corresponding int
        months = ['january', 'february', 'march', 'april', 'may', 'june']
        # Note that the month from dt come as numbers
        month = months.index(month) + 1
    
        # filter by month to create the new dataframe
        df = df[df['month']==month]
        

    # filter by day of week if applicable
    if day != 'all':
        # filter by day of week to create the new dataframe
        df = df[df['day_of_week']==day.title()]
        # print(df.head())

    return df


def time_stats(df):
    """Displays statistics on the most frequent times of travel."""

    print('\nCalculating The Most Frequent Times of Travel...\n')
    start_time = time.time()

    # TO DO: display the most common month
    print(f"Most common month: {df['month'].mode()[0]}")

    # TO DO: display the most common day of week
    print(f"Most common day of week: {df['day_of_week'].mode()[0]}")


    # TO DO: display the most common start hour
    print(f"Most common start hour: {df['Start Time'].dt.hour.mode()[0]}")

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def station_stats(df):
    """Displays statistics on the most popular stations and trip."""

    print('\nCalculating The Most Popular Stations and Trip...\n')
    start_time = time.time()
    # TO DO: display most commonly used start station
    print(f"Most commonly used start station: {df['Start Station'].mode()[0]}")

    # TO DO: display most commonly used end station
    print(f"Most commonly used end station: {df['End Station'].mode()[0]}")

    # TO DO: display most frequent combination of start station and end station trip
    print(f"Most commonly used start and end stations: "
            f"{df.groupby(['Start Station', 'End Station']).size().idxmax()}")

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def trip_duration_stats(df):
    """Displays statistics on the total and average trip duration."""

    print('\nCalculating Trip Duration...\n')
    start_time = time.time()

    # TO DO: display total travel time
    print(f"Total Trip Duration(s): {sum(df['Trip Duration'])}")

    # TO DO: display mean travel time
    print(f"Average Travel Time(s): {df['Trip Duration'].mean()}")

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def user_stats(df):
    """Displays statistics on bikeshare users."""

    print('\nCalculating User Stats...\n')
    start_time = time.time()

    # TO DO: Display counts of user types
    print(f"{df['User Type'].value_counts()}\n")
    
    # TO DO: Display counts of gender
    if 'Gender' in df.columns:
        print(f"{df['Gender'].value_counts()}\n")
    else:
        print("Gender data is not available")

    # TO DO: Display earliest, most recent, and most common year of birth
    if 'Birth Year' in df.columns:
        print(f"Earliest year of birth: {df['Birth Year'].min()}")
        print(f"Most recent year of birth: {df['Birth Year'].max()}")
        print(f"Most common year of birth: {df['Birth Year'].mode()[0]}")
    else:
        print("Birth Year data is not available")


    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def view_raw_data(df):
    """Displays 5 rows of selected data in its raw form.
    """
    # Take inout from user
    in_p = input("Would you like to see what the raw data looks like? (y/n) ")

    # Check input and print 5 rows of the df or pass.
    n = 0
    while in_p=="y":
        print(df.iloc[n:n+5])
        n = n + 5
        in_p = input("Do you wish to continue?: ").lower()
 

def main():
    while True:
        city, month, day = get_filters()
        df = load_data(city, month, day)
#         print(df.head(10))

        time_stats(df)
        station_stats(df)
        trip_duration_stats(df)
        user_stats(df)
        
        view_raw_data(df)

        restart = input('\nWould you like to restart? Enter yes or no.\n')
        if restart.lower() != 'yes':
            break


if __name__ == "__main__":
	main()
