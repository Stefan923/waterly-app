package me.stefan923.waterly.util;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public final class CsvFileWriterUtil {
    private CsvFileWriterUtil() { }

    public static void saveAsCsvFile(String dataToSave, String fileName) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(fileName))) {
            writer.write(dataToSave.replace("\"", "").replace("\\n", "\n"));
            System.out.println("Data has been written to " + fileName);
        } catch (IOException e) {
            System.err.println("Error writing data to " + fileName + ": " + e.getMessage());
        }
    }
}
