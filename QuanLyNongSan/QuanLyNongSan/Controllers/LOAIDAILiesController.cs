using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using QuanLyNongSan.Models;

namespace QuanLyNongSan.Controllers
{
    public class LOAIDAILiesController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();

        // GET: LOAIDAILies
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
            return View(db.LOAIDAILies.Where(x=>x.isXoa == false).ToList());
        }
        private bool isAdmin(string username)
        {
            TAIKHOAN tk = db.TAIKHOANs.FirstOrDefault(x => x.TaiKhoan1 == username);
            if (tk != null && tk.ISADMIN != null && (bool)tk.ISADMIN)
            {
                return true;
            }
            return false;
        }
        // GET: LOAIDAILies/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LOAIDAILY lOAIDAILY = db.LOAIDAILies.Find(id);
            if (lOAIDAILY == null)
            {
                return HttpNotFound();
            }
            return View(lOAIDAILY);
        }

        // GET: LOAIDAILies/Create
        public ActionResult Create()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            return View();
        }

        // POST: LOAIDAILies/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaLoai,Cap,MucChietKhau,isXoa")] LOAIDAILY lOAIDAILY)
        {
            if (ModelState.IsValid)
            {
                lOAIDAILY.isXoa = false;
                db.LOAIDAILies.Add(lOAIDAILY);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(lOAIDAILY);
        }

        // GET: LOAIDAILies/Edit/5
        public ActionResult Edit(int? id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LOAIDAILY lOAIDAILY = db.LOAIDAILies.Find(id);
            if (lOAIDAILY == null)
            {
                return HttpNotFound();
            }
            return View(lOAIDAILY);
        }

        // POST: LOAIDAILies/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaLoai,Cap,MucChietKhau,isXoa")] LOAIDAILY lOAIDAILY)
        {
            if (ModelState.IsValid)
            {
                lOAIDAILY.isXoa = false;
                db.Entry(lOAIDAILY).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(lOAIDAILY);
        }

        public ActionResult Delete(int id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            LOAIDAILY lOAIDAILY = db.LOAIDAILies.Find(id);
            if (lOAIDAILY == null)
            {
                return HttpNotFound();
            }
            lOAIDAILY.isXoa = false;
            db.Entry(lOAIDAILY).State = EntityState.Modified;
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
