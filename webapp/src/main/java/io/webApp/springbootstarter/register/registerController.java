package io.webApp.springbootstarter.register;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import java.util.ArrayList;

import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class registerController {

	private final static Pattern VALID_EMAIL_ADDRESS_REGEX = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$",Pattern.CASE_INSENSITIVE);
	//private final static Pattern VALID_PASSWORD_REGEX = Pattern.compile ("((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{6,20})");
	
	private String email;
	private String password;
	
	private TableCreation tableCreation;
		
	@Autowired
	private registerService rService;
	
	@Autowired
	private UserRepository userRepository;
	
	
	@RequestMapping(method=RequestMethod.POST, value="/user/register")

	public String addUser(@RequestBody register userDetails) {
		if(userDetails.getEmail().isEmpty() || userDetails.getPassword().isEmpty()) {
			return "{\"RESPONSE\" : \"Credentials should not be empty\"}";
		}

		if (checkVaildEmailAddr(userDetails.getEmail())) {
			if (checkAlreadyPresent(userDetails)) {
				return "{\"RESPONSE\" : \"User email already exists. Please Login\"}";
			}
			if (!isValidPassword(userDetails.getPassword())) {
				return "{\"RESPONSE\" : \"password should follow NIST standards\"}";
			}
			registerUser(userDetails);
			return "{\"RESPONSE\" : \"Registeration Successful\"}";
		}
		else
			return "{\"RESPONSE\" : \"Invalid emailID. Check it out !!!\"}";
	}
	
	public boolean checkVaildEmailAddr(String email) {
		System.out.println("Checking Email ID pattern");
		Matcher mat = VALID_EMAIL_ADDRESS_REGEX.matcher(email);
        return mat.find();
	}
	
	public boolean checkAlreadyPresent(register userDetails) {
		System.out.println("Checking Email ID Already present");
		ArrayList<register>dbList = new ArrayList<>(userRepository.findAll());
		
		for(register i : dbList)
		{
			if (i.getEmail().equals(userDetails.getEmail())){
				System.out.println("already registered");
				return true;
			}
		}
		return false;	
	}
	
	public boolean checkPassword(register userDetails) {
		System.out.println("Checking password");
		ArrayList<register>dbList = new ArrayList<>(userRepository.findAll());


		for(register i : dbList)
		{
			if(i.getEmail().equals(userDetails.getEmail())) {
				//String password = BCrypt.hashpw(userDetails.getPassword(), BCrypt.gensalt());
				if (BCrypt.checkpw(userDetails.getPassword(), i.getPassword())) {
				    System.out.println("It matches");
				    return true;
				}
				else
				    System.out.println("It does not match");
				}
		}
		return false;
	}
	
	public boolean isValidPassword(String password) {
		if (!(password.matches("^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"))) {
			System.out.println("Invalid password");
			return false;
		}
		return true;
	}
	
	public boolean registerUser(@RequestBody final register userData) {

		String password = BCrypt.hashpw(userData.getPassword(), BCrypt.gensalt());
		System.out.println("Password salt : " + password);
		userData.setPassword(password);
		
		userRepository.save(userData);
		return true;
	}
	
	@RequestMapping(method=RequestMethod.GET, value="/", produces = "application/json")
	public String ValidUser(@RequestHeader(value="Authorization",defaultValue="noAuth") String auth) 
	{
		
		String[] encodedValue = auth.split(" ");
		System.out.println("Auth Value:" + auth);
		String authValue = encodedValue[1];
		System.out.println("auth Value:" + authValue);
		byte[] decoded = Base64.decodeBase64(authValue.getBytes());	
		
		String decodedValue =new String(decoded);
		System.out.println("Decoded Value:" + decodedValue);
		if (decodedValue.contains(":")) {
			String[] credentialValue;
			credentialValue = decodedValue.split(":");
			if (credentialValue.length < 2) {
				return "{\"RESPONSE\" : \"Credentials should not be empty\"}";
			}
			email = credentialValue[0];
			password = credentialValue[1];
		}
		else {
			return "{\"RESPONSE\" : \"Please register\"}";
		}
		System.out.println("email : " + email + "/t" + "password : " + password);
		
		//check for empty strings
		if(email.isEmpty() || password.isEmpty()) {
			return "{\"RESPONSE\" : \"Enter valid Credentials\"}";
		}
		register userDetails = new register(email,password);

		if(!checkVaildEmailAddr(email) || ! checkAlreadyPresent(userDetails) || ! checkPassword(userDetails)) 
		{
			return "{\"RESPONSE\" : \"Invalid credentials\"}";
		}
		else 
		{
			String time =  "{\"RESPONSE: Token Authenticated \" : " + currentTime() + "\"}\"";
			return time;
					//JSONObject.quote(currentTime());
		}
	}
	
	public String currentTime() {
		currentTime Ctime = new currentTime(); 
		return Ctime.getCurrentTime();
	}	

}
