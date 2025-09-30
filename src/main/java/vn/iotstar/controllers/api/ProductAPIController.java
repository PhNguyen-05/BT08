package vn.iotstar.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.iotstar.entity.Product;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ProductService;
import vn.iotstar.service.CategoryService;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/product")
public class ProductAPIController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

   
    @GetMapping
    public ResponseEntity<List<Product>> getAll() {
        return ResponseEntity.ok(productService.findAll());
    }

  
    @GetMapping("/sorted")
    public ResponseEntity<List<Product>> getAllSorted() {
        return ResponseEntity.ok(productService.findAllSortedByPrice());
    }

   
    @GetMapping("/by-category")
    public ResponseEntity<List<Product>> getByCategory(@RequestParam Long categoryId) {
        return ResponseEntity.ok(productService.findByCategoryId(categoryId));
    }

 
    @PostMapping("/add")
    public ResponseEntity<Product> add(@RequestParam String title,
                                       @RequestParam Integer quantity,
                                       @RequestParam Double price,
                                       @RequestParam String description,
                                       @RequestParam Long categoryId) {
        Product p = new Product();
        p.setTitle(title);
        p.setQuantity(quantity);
        p.setPrice(price);
        p.setDescription(description);

        Optional<Category> cat = categoryService.findById(categoryId);
        cat.ifPresent(p::setCategory);

        return ResponseEntity.ok(productService.save(p));
    }


    @PutMapping("/update")
    public ResponseEntity<Product> update(@RequestParam Long id,
                                          @RequestParam String title,
                                          @RequestParam Integer quantity,
                                          @RequestParam Double price,
                                          @RequestParam String description,
                                          @RequestParam Long categoryId) {
        Optional<Product> opt = productService.findById(id);
        if (opt.isEmpty()) return ResponseEntity.notFound().build();

        Product p = opt.get();
        p.setTitle(title);
        p.setQuantity(quantity);
        p.setPrice(price);
        p.setDescription(description);

        Optional<Category> cat = categoryService.findById(categoryId);
        cat.ifPresent(p::setCategory);

        return ResponseEntity.ok(productService.save(p));
    }

    // Xoá product
    @DeleteMapping("/delete")
    public ResponseEntity<?> delete(@RequestParam Long id) {
        Optional<Product> opt = productService.findById(id);
        if (opt.isEmpty()) return ResponseEntity.notFound().build();

        productService.delete(id);
        return ResponseEntity.ok().build();
    }
}