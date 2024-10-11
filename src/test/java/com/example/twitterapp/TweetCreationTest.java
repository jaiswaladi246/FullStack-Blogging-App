package com.example.twitterapp;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public class TweetCreationTest {
    WebDriver driver;

    @BeforeMethod
    public void setUp() {
        System.setProperty("webdriver.chrome.driver", "/path/to/chromedriver");
        driver = new ChromeDriver();
        driver.get("http://localhost:8080/login");
        driver.findElement(By.id("username")).sendKeys("admin");
        driver.findElement(By.id("password")).sendKeys("admin123");
        driver.findElement(By.id("loginButton")).click();
    }

    @Test
    public void createNewTweet() {
        driver.findElement(By.id("newTweet")).click();
        driver.findElement(By.id("tweetContent")).sendKeys("This is a test tweet.");
        driver.findElement(By.id("submitTweet")).click();
        // Add validation to ensure the tweet was created
    }

    @AfterMethod
    public void tearDown() {
        driver.quit();
    }
}
