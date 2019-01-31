package io.webApp.springbootstarter.register;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


import org.springframework.stereotype.Service;

@Service
public class registerService {
	
	TableCreation tableCreation;

	List<register> rUser = new ArrayList<>( Arrays.asList(
			new register("anbalagan.s@husky.neu.edu", "password1"),
			new register("gadhiya.h@husky.neu.edu", "password2"),
			new register("gopalareddy.p@husky.neu.edu", "password3"),
			new register("murgod.a@husky.neu.edu", "password4"),
			new register("prabhu.a@husky.neu.edu", "password5")));
	
	public List<register> registeredUser(){
		return rUser;
	}
	
	public register getRegister(String emailID) {
		return rUser.stream().filter(t -> t.getEmail().equals(emailID)).findFirst().get();
	}
	
	public void dbCreation() {
		tableCreation.createDB();
	}
}
