package br.unb.cic.hephaestus.preprocessor.antenna;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.*;
import java.nio.charset.*;
import java.util.List;

import antenna.preprocessor.v3.PreprocessorBridge;


public class Main {

	public static void main(String args[]) {
		if(args.length == 2) {
			try {
				List<String> files = Files.readAllLines(Paths.get(args[0]), Charset.forName("UTF-8"));
				List<String> tags  = Files.readAllLines(Paths.get(args[1]), Charset.forName("UTF-8"));
				
				PreprocessorBridge pp = new PreprocessorBridge(null);
				
				for(String tag: tags) {
					pp.addSymbols(tag);
				}
				
				for(String f: files) {
					System.out.println("[Hephaestus PreProcessor] preprocessing file: " + f);
					InputStream in   = new FileInputStream(new File(f));
					OutputStream out = new FileOutputStream(new File(f + ".tmp"));
					pp.preprocess(in, out, "UTF-8");	
					in.close();
					out.close();
					
					File tmpFile = new File(f + ".tmp");
				    boolean success = tmpFile.renameTo(new File(f));
					
				    System.out.print("- renaming temp file");
				    if(success) {
				    	System.out.println("... [ok] ");
				    }
				    else {
				    	System.out.println("...[nok]");
				    }
				    
				    //tmpFile = new File(f + ".tmp");
					//success = tmpFile.delete();
					
					//System.out.println(" - deleting temp file");
					
					//System.out.println("[Hephaestus PreProcessor] output: " + f);
				}
				
			}
			catch(Exception e) {
				System.out.println("error: " + e.getMessage());
			}
		}
		else {
			System.out.println("Expecting two command line arguments. ");
			System.out.println("USAGE: java - jar antenna-pp.jar <ppfiles_file> <tags_file>");
		}
	}
}
