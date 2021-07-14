package jiangmh.demo.crm.settings.dao;

import jiangmh.demo.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    User userLogin(Map map);

    List<User> getUserList();
}
