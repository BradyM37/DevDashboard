package com.devdashboard.controller;

import com.devdashboard.model.Repository;
import com.devdashboard.service.GitHubService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class DashboardController {

    private final GitHubService gitHubService;

    @Autowired
    public DashboardController(GitHubService gitHubService) {
        this.gitHubService = gitHubService;
    }

    @GetMapping("/")
    public String home() {
        return "home";  // This will use home.html for the home page
    }

    @PostMapping("/search")
    public String searchRepositories(@RequestParam String username, Model model) {
        List<Repository> repositories = gitHubService.getRepositoriesByUsername(username);
        
        model.addAttribute("repositories", repositories);
        model.addAttribute("username", username);
        
        // Add error message if no repositories found
        if (repositories.isEmpty()) {
            model.addAttribute("errorMessage", 
                "No repositories found for '" + username + "'. Please check the username and try again.");
        }
        
        return "dashboard";  // This will use dashboard.html for search results
    }
}