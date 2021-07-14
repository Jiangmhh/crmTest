package jiangmh.demo.crm.web.listener;

import jiangmh.demo.crm.workbench.domain.DicValue;
import jiangmh.demo.crm.workbench.service.DicService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.annotation.Resource;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String config = "conf/applicationContext.xml";
        ApplicationContext ac = new ClassPathXmlApplicationContext(config);
        DicService dicService = (DicService) ac.getBean("dicService");
        System.out.println("全局作用域对象创建");

        // 获取数据字典
        Map<String, List<DicValue>> map =  dicService.getDicList();
        Set<String> set = map.keySet();
        for(String key : set){
//            System.out.println(key);
//            System.out.println(map.get(key));

            sce.getServletContext().setAttribute(key, map.get(key));
        }

        // 处理Stage2Possibility.properties
        ResourceBundle rb = ResourceBundle.getBundle("/conf/Stage2Possibility");
        Map<String,String> pMap = new HashMap();
        Enumeration<String> e = rb.getKeys();
        while (e.hasMoreElements()){
            String key = e.nextElement();
            String value = rb.getString(key);
            pMap.put(key,value);
        }
        sce.getServletContext().setAttribute("pMap",pMap);
    }

}
