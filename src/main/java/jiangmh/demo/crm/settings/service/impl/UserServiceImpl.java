package jiangmh.demo.crm.settings.service.impl;

import jiangmh.demo.crm.exception.LoginException;
import jiangmh.demo.crm.settings.dao.UserDao;
import jiangmh.demo.crm.settings.domain.User;
import jiangmh.demo.crm.settings.service.UserService;
import jiangmh.demo.crm.utils.DateTimeUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// 业务方法
@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao userDao;

    @Override
//    @Transactional  // 添加事务
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        // 连接数据库
        Map map = new HashMap();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userDao.userLogin(map);

        if(user == null){
            throw new LoginException("用户名或密码错误");
        }
        // 验证ip
        String allowIps = user.getAllowIps();
        if( !allowIps.contains(ip)){
            throw new LoginException("非法ip地址");
        }
        // 验证失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if(currentTime.compareTo(expireTime) > 0){
            throw new LoginException("登入失效");
        }

        // 验证锁定状态
        if("0".equals(user.getLockState())){
            throw new LoginException("用户已锁定");
        }
        return user;
    }

    @Override
    public List<User> getUserList() {
        List<User> userList = userDao.getUserList();
        return userList;
    }
}
