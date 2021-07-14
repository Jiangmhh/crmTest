package jiangmh.demo.crm.settings.service;

import jiangmh.demo.crm.exception.LoginException;
import jiangmh.demo.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {

    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
