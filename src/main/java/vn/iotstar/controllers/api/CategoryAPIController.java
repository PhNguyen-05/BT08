package vn.iotstar.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.iotstar.entity.Category;
import vn.iotstar.model.Response;
import vn.iotstar.service.CategoryService;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/category")
public class CategoryAPIController {

    @Autowired
    private CategoryService categoryService;

    // Lấy tất cả category
    @GetMapping
    public ResponseEntity<?> getAllCategories() {
        List<Category> categories = categoryService.findAll();
        return ResponseEntity.ok(new Response(true, "Thành công", categories));
    }

    // Lấy category theo id
    @GetMapping("/{id}")
    public ResponseEntity<?> getCategory(@PathVariable Long id) {
        Optional<Category> category = categoryService.findById(id);
        if (category.isPresent()) {
            return ResponseEntity.ok(new Response(true, "Thành công", category.get()));
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new Response(false, "Không tìm thấy category", null));
    }

    // Thêm mới
    @PostMapping
    public ResponseEntity<?> addCategory(@RequestBody Category category) {
        Optional<Category> existed = categoryService.findByName(category.getName());
        if (existed.isPresent()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new Response(false, "Category đã tồn tại", null));
        }
        Category saved = categoryService.save(category);
        return ResponseEntity.ok(new Response(true, "Thêm thành công", saved));
    }

    // Cập nhật
    @PutMapping("/{id}")
    public ResponseEntity<?> updateCategory(@PathVariable Long id, @RequestBody Category updated) {
        Optional<Category> opt = categoryService.findById(id);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new Response(false, "Không tìm thấy category", null));
        }
        Category c = opt.get();
        c.setName(updated.getName());
        c.setImages(updated.getImages());
        Category saved = categoryService.save(c);
        return ResponseEntity.ok(new Response(true, "Cập nhật thành công", saved));
    }

    // Xóa
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCategory(@PathVariable Long id) {
        Optional<Category> opt = categoryService.findById(id);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new Response(false, "Không tìm thấy category", null));
        }
        categoryService.delete(id);
        return ResponseEntity.ok(new Response(true, "Xóa thành công", null));
    }
}