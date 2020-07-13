using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace QuanLyNongSan.Controllers
{
    public class BieuThucChinhQuyController : Controller
    {
        // GET: BieuThucChinhQuy
        public ActionResult Index(string ValueSearch11)
        {
            if (!string.IsNullOrEmpty(ValueSearch11))
            {
                ViewBag.SQLString = ValueSearch11;
                var path = Path.Combine(Server.MapPath("~/App_Data/uploads/Quanlycungung_26.05.2020.owl"));
                string textLine = System.IO.File.ReadAllText(path);
                string pattern = ".*"+ ValueSearch11 + ".*";
                Regex r = new Regex(pattern);
                List<string> matches = r.Matches(textLine)
                .Cast<Match>()
                .Select(m => m.Value)
                .Distinct()
                .ToList();

                ViewBag.Data = matches;
            }
            return View();
        }
    }
}