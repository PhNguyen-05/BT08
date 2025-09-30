package vn.iotstar.graphql;

import com.netflix.graphql.dgs.*;
import org.springframework.beans.factory.annotation.Autowired;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;

import java.util.List;
import java.util.Optional;

@DgsComponent
public class UserDataFetcher {

    @Autowired
    private UserService userService;

    @DgsQuery
    public List<User> users() {
        return userService.findAll();
    }

    @DgsQuery
    public User user(@InputArgument Long id) {
        return userService.findById(id).orElse(null);
    }

    @DgsMutation
    public User addUser(@InputArgument String fullname,
                        @InputArgument String email,
                        @InputArgument String password,
                        @InputArgument String phone) {
        User u = new User();
        u.setFullname(fullname);
        u.setEmail(email);
        u.setPassword(password);
        u.setPhone(phone);
        return userService.save(u);
    }

    @DgsMutation
    public User updateUser(@InputArgument Long id,
                           @InputArgument String fullname,
                           @InputArgument String email,
                           @InputArgument String password,
                           @InputArgument String phone) {
        Optional<User> opt = userService.findById(id);
        if (opt.isEmpty()) return null;

        User u = opt.get();
        if (fullname != null) u.setFullname(fullname);
        if (email != null) u.setEmail(email);
        if (password != null) u.setPassword(password);
        if (phone != null) u.setPhone(phone);

        return userService.save(u);
    }

    @DgsMutation
    public Boolean deleteUser(@InputArgument Long id) {
        Optional<User> opt = userService.findById(id);
        if (opt.isEmpty()) return false;
        userService.delete(id);
        return true;
    }
}