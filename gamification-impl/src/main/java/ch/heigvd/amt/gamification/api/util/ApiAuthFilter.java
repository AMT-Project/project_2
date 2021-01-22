package ch.heigvd.amt.gamification.api.util;

import ch.heigvd.amt.gamification.entities.ApplicationEntity;
import ch.heigvd.amt.gamification.repositories.ApplicationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component
@Order(1)
public class ApiAuthFilter implements javax.servlet.Filter {

    @Autowired
    ApplicationRepository applicationRepository;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // White list of URLs accessible publicly
        if(req.getRequestURI().startsWith("/swagger") || req.getRequestURI().startsWith("/v3") || req.getRequestURI().equals("/")) {
            chain.doFilter(request, response);
        }

        // Get API key from request and obtain related Application entity
        String apiKey = req.getHeader("X-API-KEY");
        ApplicationEntity applicationEntity = applicationRepository.findAllByApiKey(apiKey);

        try {
            // Application is not found
            if(applicationEntity == null) {
                // Application doesn't exist but it's a new registration => Create Application and return API key - 201 : Created
                if(req.getRequestURI().startsWith("/applications") && req.getMethod().equals("POST")) {
                    res.setStatus(201);
                    chain.doFilter(request, response);

                } // Application doesn't exist => 401 : Unauthorized
                else {
                    res.setStatus(401);
                }
            } // Application exists => add it to the request and chain filter
            else {
                req.setAttribute("applicationEntity", applicationEntity);
                chain.doFilter(request, response);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void destroy() {
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
}
