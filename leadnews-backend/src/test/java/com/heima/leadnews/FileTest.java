package com.heima.leadnews;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.File;

@SpringBootTest
public class FileTest {

    @Test
    public void TestFileApi(){
        File file = new File("E:\\AI\\leadnews\\app.log");

        System.out.println(file.getAbsoluteFile());

        System.out.println(file.getPath());

        System.out.println(file.getName());
    }
}
