package vn.iotstar.graphql;

import com.netflix.graphql.dgs.*;
import org.springframework.beans.factory.annotation.Autowired;
import vn.iotstar.entity.Product;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.service.ProductService;
import vn.iotstar.service.CategoryService;
import vn.iotstar.service.UserService;

import java.util.List;
import java.util.Optional;

@DgsComponent
public class ProductDataFetcher {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private UserService userService;

    @DgsQuery
    public List<Product> products() {
        return productService.findAll();
    }

    @DgsQuery
    public Product product(@InputArgument Long id) {
        return productService.findById(id).orElse(null);
    }

    @DgsQuery
    public List<Product> productsSortedByPrice() {
        return productService.findAllSortedByPrice();
    }

    @DgsQuery
    public List<Product> productsByCategory(@InputArgument Long categoryId) {
        return productService.findByCategoryId(categoryId);
    }

    @DgsMutation
    public Product addProduct(@InputArgument String title,
                              @InputArgument Integer quantity,
                              @InputArgument String description,
                              @InputArgument Double price,
                              @InputArgument Long categoryId,
                              @InputArgument Long userId) {
        Product p = new Product();
        p.setTitle(title);
        p.setQuantity(quantity);
        p.setDescription(description);
        p.setPrice(price);

        Optional<Category> cat = categoryService.findById(categoryId);
        cat.ifPresent(p::setCategory);

        Optional<User> user = userService.findById(userId);
        user.ifPresent(p::setUser);

        return productService.save(p);
    }

    @DgsMutation
    public Product updateProduct(@InputArgument Long id,
                                 @InputArgument String title,
                                 @InputArgument Integer quantity,
                                 @InputArgument String description,
                                 @InputArgument Double price,
                                 @InputArgument Long categoryId,
                                 @InputArgument Long userId) {
        Optional<Product> opt = productService.findById(id);
        if (opt.isEmpty()) return null;

        Product p = opt.get();
        if (title != null) p.setTitle(title);
        if (quantity != null) p.setQuantity(quantity);
        if (description != null) p.setDescription(description);
        if (price != null) p.setPrice(price);

        if (categoryId != null) {
            categoryService.findById(categoryId).ifPresent(p::setCategory);
        }
        if (userId != null) {
            userService.findById(userId).ifPresent(p::setUser);
        }

        return productService.save(p);
    }

    @DgsMutation
    public Boolean deleteProduct(@InputArgument Long id) {
        Optional<Product> opt = productService.findById(id);
        if (opt.isEmpty()) return false;
        productService.delete(id);
        return true;
    }
}