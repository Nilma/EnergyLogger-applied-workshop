import org.springframework.boot.SpringApplication;
import org.springframework.boot.SpringBootConfiguration;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;

@SpringBootConfiguration
@EnableAutoConfiguration
public class CakeShopApplication {

    public static void main(String[] args) {
        SpringApplication.run(CakeShopApplication.class, args);
    }
}