package jiangmh.demo.crm.settings.web.interceptor;

import jiangmh.demo.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {
    /*
     * @param handler : 被拦截的控制器对象
     * 用户请求先到达此方法 方法中验证请求的信息,验证请求是否符合要求
     *                1.如果验证通过,可以放行请求,此控制器方法执行
     *                2.如果验证失败,截断请求,请求不能被处理
     * 返回值 true:
     *      执行拦截器preHandle
     *      执行doSome方法
     *      执行拦截器postHandle
     *      执行拦截器afterCompletion
     *      false:
     *      执行拦截器preHandle(不往下执行)
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        return true;
    }

    /**
     *
     * @param handler : 被拦截的控制器对象
     * @param modelAndView : 处理器方法的返回值
     * 特点:
     *   1.在处理器方法之后执行(MyController.doSome())
     *   2.获取处理器方法的返回值ModelAndView,可以修改ModelAndView中的数据和视图,影响最后的执行结果
     *   (对原来的执行结果进行二次修改)
     *
     */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    /**
     * @param handler
     * @param ex : 程序中发生的异常
     *   请求处理完成后执行, （当视图处理完成后,认为请求完成）
     *   资源回收工作
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }

}
