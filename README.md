# LocAI

## Project Description  
LocAI is a mobile app that helps users find places more naturally by allowing them to type queries in everyday language. Instead of relying on fixed filters, the app converts user input into structured Google Maps API parameters (such as place type, keyword, radius, or open status) and returns the most relevant results. The results are displayed as a simple list with key details like name, rating, and address, and users can open the selected place directly in the Google Maps app for directions.  

Firebase is used to store user favorites, search history, and preferences, making the experience more personal over time.  

## Team Members  
- **Ahmet Taha Kahya** – 32635  
- **Pelin Özçelik** – 30403  
- **Ecehan Kalkan** – 22628  
- **Can Demirtaş** – 32091  
- **Tuna Kubat** – 31198  

## App Structure
```
/assets
  /fonts
  /images
/lib
  /pages
     /home
       home_page.dart
     ...
  /state
     favorites_state.dart
  /utils
     colors.dart
     paddings.dart
     text_styles.dart
  /widgets
     custom_app_bar.dart
     place_card.dart
```

- **assets:** Includes the local images and custom fonts.

- **lib/pages:** Stores the files for all pages.

- **lib/state:** Manages the states that are accessed and updated by multiple pages.

- **lib/utils:** Includes utility classes that organize static data into separate files.

- **lib/widgets:** Stores the custom widgets. For an example, the place_card.dart file provides a way to reuse our custom card widget in multiple pages easily. 

This readme file will be updated as the project progresses.

**Update:** Google Maps API is going to integrated in the last step of the project. For now, in the home page, we still display placeholder data.