import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  static const String apikey = 'ff1a23fcb7c172875088671056935c34';
  static const String baseUrl =  'https://api.themoviedb.org/3';
  
  Future<List<Map<String, dynamic>>> getAllMovie() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/now_playing?api_key=$apikey'),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<List<Map<String, dynamic>>> getAllMovieBearer() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/now_playing?api_key=$apikey'),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<List<Map<String, dynamic>>> getTrendingMovie() async {
    final response = await http.get(
      Uri.parse('$baseUrl/trending/movie/week?api_key=$apikey'),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apikey'),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/movie?query=$query&api_key=$apikey'),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
}