package vn.iotstar.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/user")
public class UserAPIController {

    @Autowired
    private UserService userService;

    
    @GetMapping
    public ResponseEntity<List<User>> getAll() {
        return ResponseEntity.ok(userService.findAll());
    }

   
    @PostMapping("/add")
    public ResponseEntity<User> add(@RequestParam String fullname,
                                    @RequestParam String email,
                                    @RequestParam String password,
                                    @RequestParam String phone) {
        User u = new User();
        u.setFullname(fullname);
        u.setEmail(email);
        u.setPassword(password);
        u.setPhone(phone);

        return ResponseEntity.ok(userService.save(u));
    }

    // Cập nhật user
    @PutMapping("/update")
    public ResponseEntity<User> update(@RequestParam Long id,
                                       @RequestParam String fullname,
                                       @RequestParam String email,
                                       @RequestParam String password,
                                       @RequestParam String phone) {
        Optional<User> opt = userService.findById(id);
        if (opt.isEmpty()) return ResponseEntity.notFound().build();

        User u = opt.get();
        u.setFullname(fullname);
        u.setEmail(email);
        u.setPassword(password);
        u.setPhone(phone);

        return ResponseEntity.ok(userService.save(u));
    }

    // Xoá user
    @DeleteMapping("/delete")
    public ResponseEntity<?> delete(@RequestParam Long id) {
        Optional<User> opt = userService.findById(id);
        if (opt.isEmpty()) return ResponseEntity.notFound().build();

        // ✅ Gọi đúng method delete(Long id) trong UserService
        userService.delete(id);
        return ResponseEntity.ok().build();
    }
}