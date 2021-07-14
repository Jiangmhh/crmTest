public class Test {
    public static void main(String[] args) {
        String s = "aid=06abcc44ef6a45f0912a4abf348a4cae&aid=532ddf6bc53a499985632ac67f3d394e&aid=fd9ead9cccd24685b91b66fd13186157";
        String a = s.replace("aid=","");

//        System.out.println(a);
        String[] str = a.split("&");
        System.out.println(111111111);
        for(String i : str){
            System.out.println(i);

        }
    }
}
