import 'package:flutter/material.dart';


class SearchGlobal extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
       return [
         IconButton(icon: Icon(Icons.search), onPressed: (){
                 
         })
       ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
           return null ; 
    }
  
    @override
    Widget buildResults(BuildContext context) {
            return null  ; 
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
 
       return Text("hay search delegate") ; 
  
  }

}