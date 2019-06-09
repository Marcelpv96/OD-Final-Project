import bs4
import urllib.request as urllib

class Scraper(object):
    
    def get_web(self, web_page):
        """
        Get Webpage html
        """
        f = urllib.urlopen(web_page)
        html = f.read()
        f.close()
        return html
    
    
    def get_app_name(self, html_page):
        """
        Get app name
        """
        bs = bs4.BeautifulSoup(html_page, "lxml")
        app_name = bs.find_all('span', {'class' : "a-size-large a-text-bold"})[0].text
        return app_name
    
    def main(self, web_page):
        html_page = self.get_web(web_page)
        app_name = self.get_app_name(html_page)
        return app_name
