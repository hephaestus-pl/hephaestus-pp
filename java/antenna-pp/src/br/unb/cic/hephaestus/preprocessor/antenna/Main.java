package br.unb.cic.hephaestus.preprocessor.antenna;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.nio.file.*;
import java.nio.charset.*;
import java.util.List;

import antenna.preprocessor.PreprocessorException;
import antenna.preprocessor.v3.PreprocessorBridge;


public class Main {

	public static void main(String args[]) {
		System.out.println("number of arguments: " + args.length);
		if(args.length == 3 || (args[2].equals("--drop-lines") || args[2].equals("--comment-lines"))) {
			try {
				List<String> files = Files.readAllLines(Paths.get(args[0]), Charset.forName("UTF-8"));
				List<String> tags  = Files.readAllLines(Paths.get(args[1]), Charset.forName("UTF-8"));
				
				PreprocessorBridge pp = new PreprocessorBridge(null);
				
				for(String tag: tags) {
					pp.addSymbols(tag);
				}
				
				for(String f: files) {
					runPreprocessor(pp, f);
				    if(args[2].equals("--drop-lines")) {
				    	dropLines(args, f);
				    }
				}
			}
			catch(Exception e) {
				e.printStackTrace();
				System.out.println("error: " + e.getMessage());
			}
		}
		else {
			showErrorMessage();
		}
	}

	private static void runPreprocessor(PreprocessorBridge pp, String f)
			throws FileNotFoundException, IOException, PreprocessorException {
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
	}

	private static void dropLines(String[] args, String f)
			throws IOException {
		List<String> lines = Files.readAllLines(Paths.get(f), Charset.forName("UTF-8"));
		PrintWriter pw = new PrintWriter(new FileWriter(f));
		boolean empty = false;
	
		for (String string : lines) {
			if(!string.trim().startsWith("//#")) {
				if(string.trim().equals("") && !empty) {
					pw.println(string);
					empty = true;
				}
				else if (!string.trim().equals("")) {
					pw.println(string);
					empty = false;
				}
			}
		}
	
		pw.flush();
		pw.close();
	}
	
	private static void showErrorMessage() {
		System.out.println("Expecting three command line arguments. ");
		System.out.println("USAGE: java - jar antenna-pp.jar <ppfiles_file> <tags_file> <--drop-lines | --comment-lines>");
	}
}
