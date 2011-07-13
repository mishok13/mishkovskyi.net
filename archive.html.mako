<%inherit file="_templates/site.mako" />
<p>
 This is the list of all blog posts ever written.
</p>

Here's the main <a href="${bf.util.site_path_helper(bf.config.blog.path)}">chronological blog page</a><br/><br/>

Here's the last 5 posts:
<ul>
% for post in bf.config.blog.posts:
    <li><a href="${post.path}">${post.title}</a></li>
% endfor
</ul>
