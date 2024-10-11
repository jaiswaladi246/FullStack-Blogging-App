package com.example.twitterapp;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public class TweetDeletionTest {
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
    public void deleteTweet() {
        driver.findElement(By.xpath("//button[contains(text(),'Delete Tweet')]")).click();
        // Add validation to ensure the tweet was deleted
    }

    @AfterMethod
    public void tearDown() {
        driver.quit();
    }
}
