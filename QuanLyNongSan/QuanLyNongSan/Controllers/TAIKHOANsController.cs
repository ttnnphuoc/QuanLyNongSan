using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using QuanLyNongSan.Models;
using System.Security.Cryptography;
using System.Text;
using Core;
namespace QuanLyNongSan.Controllers
{
    public class TAIKHOANsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();

        // GET: TAIKHOANs
        public ActionResult Index()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }

            ViewBag.IsAdmin = "hidden-menu";
            ViewBag.Add = "disable-btn";
            if (isAdmin(Session["username"] + ""))
            {
                ViewBag.Add = "";
                ViewBag.IsAdmin = "";
            }
            return View(db.TAIKHOANs.ToList());
        }

        // GET: TAIKHOANs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            TAIKHOAN tAIKHOAN = db.TAIKHOANs.Find(id);
            if (tAIKHOAN == null)
            {
                return HttpNotFound();
            }
            return View(tAIKHOAN);
        }

        public ActionResult Login()
        {
            if (Session["username"] != null)
            {
                return RedirectToAction("Index", "SanPhams");
            }
            return View();
        }

        [HttpPost]
        public ActionResult Login(string userName, string passWord)
        {
            string mk = createMD5(passWord);
            TAIKHOAN tk = db.TAIKHOANs.FirstOrDefault(x => x.TaiKhoan1.Equals(userName) && x.MatKhau.Equals(mk));
            if (tk != null)
            {
                Session["username"] = tk.TaiKhoan1;
                return RedirectToAction("Index", "SanPhams");
            }
            return View();
        }
        // GET: TAIKHOANs/Create
        public ActionResult Create()
        {
            if (Session["username"] != null)
            {
                return RedirectToAction("Index", "SanPhams");
            }
            return View();
        }

        // POST: TAIKHOANs/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        public ActionResult Create([Bind(Include = "ID,TaiKhoan1,MatKhau,HoTen")] TAIKHOAN tAIKHOAN)
        {
            TAIKHOAN newTaiKhoan = db.TAIKHOANs.FirstOrDefault(x => x.TaiKhoan1.Equals(tAIKHOAN.TaiKhoan1));
            if (newTaiKhoan != null)
            {
                ViewBag.Message = "Tài Khoản Đã Tồn Tại";
                return View();
            }

            if (ModelState.IsValid)
            {
                tAIKHOAN.MatKhau = createMD5(tAIKHOAN.MatKhau);
                db.TAIKHOANs.Add(tAIKHOAN);
                db.SaveChanges();
                Session["username"] = null;
                return RedirectToAction("Login","TaiKhoans");
            }

            return View(tAIKHOAN);
        }

        public string createMD5(string pass)
        {
            MD5 md5 = MD5.Create();
            byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(pass);
            byte[] hash = md5.ComputeHash(inputBytes);
            StringBuilder sb = new StringBuilder();

            for (int i = 0;i <hash.Length; i++)
            {
                sb.Append(hash[i].ToString("X2"));
            }
            return sb.ToString();
        }
        // GET: TAIKHOANs/Edit/5
        public ActionResult Edit(int? id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Index", "SanPhams");
            }
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            TAIKHOAN tAIKHOAN = db.TAIKHOANs.Find(id);
            if (tAIKHOAN == null)
            {
                return HttpNotFound();
            }
            return View(tAIKHOAN);
        }

        public ActionResult LogOut()
        {
            Session["username"] = null;
            return RedirectToAction("Login", "TaiKhoans");
        }
        // POST: TAIKHOANs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,TaiKhoan1,MatKhau,HoTen")] TAIKHOAN tAIKHOAN)
        {
            if (ModelState.IsValid)
            {
                TAIKHOAN tk = db.TAIKHOANs.FirstOrDefault(x => x.TaiKhoan1 == tAIKHOAN.TaiKhoan1);
                if (tk.MatKhau != tAIKHOAN.MatKhau)
                {
                    string md5 = createMD5(tAIKHOAN.MatKhau);
                    tAIKHOAN.MatKhau = md5;
                }
                db.Entry(tAIKHOAN).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(tAIKHOAN);
        }
        public bool isAdmin(string username)
        {
            TAIKHOAN tk = db.TAIKHOANs.FirstOrDefault(x => x.TaiKhoan1 == username);
            if (tk != null && tk.ISADMIN != null && (bool)tk.ISADMIN)
            {
                return true;
            }
            return false;
        }
        public ActionResult Delete(int id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Index", "SanPhams");
            }
            TAIKHOAN tAIKHOAN = db.TAIKHOANs.Find(id);
            db.TAIKHOANs.Remove(tAIKHOAN);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
