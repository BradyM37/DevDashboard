package com.devdashboard.service;

import com.devdashboard.model.Repository;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.logging.Logger;

@Service
public class GitHubService {

    private final RestTemplate restTemplate;
    private static final String API_URL = "https://api.github.com/users/{username}/repos";
    private static final Logger logger = Logger.getLogger(GitHubService.class.getName());

    public GitHubService() {
        this.restTemplate = new RestTemplate();
    }

    public List<Repository> getRepositoriesByUsername(String username) {
        try {
            logger.info("Fetching repositories for user: " + username);
            
            // Build the URI with query parameters
            URI uri = UriComponentsBuilder.fromUriString(API_URL)
                    .queryParam("per_page", 100)  // Get up to 100 repos per page
                    .queryParam("sort", "updated")
                    .buildAndExpand(username)
                    .toUri();
            
            // Create headers with user agent (GitHub API requires a user agent)
            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "DevDashboard-App");
            
            // Create the request entity with headers
            RequestEntity<Void> requestEntity = new RequestEntity<>(headers, HttpMethod.GET, uri);
            
            // Make the request
            ResponseEntity<Repository[]> response = restTemplate.exchange(
                    requestEntity, 
                    Repository[].class
            );
            
            Repository[] repositories = response.getBody();
            
            if (repositories != null) {
                logger.info("Found " + repositories.length + " repositories");
                return Arrays.asList(repositories);
            } else {
                logger.warning("No repositories found or null response");
                return Collections.emptyList();
            }
        } catch (HttpClientErrorException.NotFound e) {
            logger.severe("User not found: " + username);
            return Collections.emptyList();
        } catch (Exception e) {
            logger.severe("Error fetching repositories: " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}