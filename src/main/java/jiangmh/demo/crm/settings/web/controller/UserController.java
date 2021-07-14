package jiangmh.demo.crm.settings.web.controller;

import jiangmh.demo.crm.settings.domain.User;
import jiangmh.demo.crm.settings.service.UserService;
import jiangmh.demo.crm.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/settings/user")
public class UserController {
    @Resource
    private UserService userService;

    // 用户登入 响应ajax请求
    @RequestMapping(value = "/login.do")
    @ResponseBody
    // 逐个接受参数 方法的形参名和请求中的参数名一致
    public Map loginController(String loginAct, String loginPwd, HttpServletRequest request){
        // 获取ip
        String ip = request.getRemoteAddr();
        System.out.println("欢迎来到登入页面");
        // 将密码转换为密文
        loginPwd = MD5Util.getMD5(loginPwd);
        System.out.println(ip);
        System.out.println(loginAct);
        System.out.println(loginPwd);
        // 调用业务层login方法
        Map map = new HashMap();
        try{
            User user  = userService.login(loginAct,loginPwd,ip);
            // 存入session中
            request.getSession().setAttribute("user",user);
            map.put("success",true);
        }catch (Exception e){
            e.printStackTrace();
            String msg = e.getMessage();
            map.put("msg",msg);
        }
        // 响应ajax请求  data: {"success" :true/false, "msg": "错误位置"}
        return map;
    }
}
