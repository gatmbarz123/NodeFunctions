package com.example;

import org.junit.Test;
import static org.junit.Assert.*;

public class AppTest {
    @Test
    public void testApp() {
        App app = new App();
        assertEquals("Hello from Simple Java App!", app.getGreeting());
    }
}