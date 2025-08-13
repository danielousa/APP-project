using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GestaoCondominios.api.Models;
using GestaoCondominios.api.DTOs;

namespace GestaoCondominios.api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CodigoPostalsController : ControllerBase
    {
        private readonly GestaoCondominiosContext _context;

        public CodigoPostalsController(GestaoCondominiosContext context)
        {
            _context = context;
        }

        // GET: api/CodigoPostals
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CodigoPostalDTO>>> GetCodigoPostals()
        {
            List<CodigoPostalDTO> list = new List<CodigoPostalDTO>();

            var codigoPostal = await _context.CodigoPostals.ToListAsync();

            foreach (var cod in codigoPostal)
            {
                list.Add(new CodigoPostalDTO().ModelCodigoPostalToDto(cod));
            }

            return list;
        }

        // GET: api/CodigoPostals/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CodigoPostalDTO>> GetCodigoPostal(string id)
        {

            var codigoPostal = await _context.CodigoPostals.Where(tp => tp.IdCodigoPostal == id).ToListAsync();

            if (codigoPostal.Count == 0)
            {
                return NotFound();
            }

            return new CodigoPostalDTO().ModelCodigoPostalToDto(codigoPostal.First());

        }

        // PUT: api/CodigoPostals/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCodigoPostal(string id, CodigoPostalDTO codigoPostal)
        {


            if (id != codigoPostal.IdCodigoPostal)
            {
                return BadRequest();
            }

            if (!CodigoPostalExists(id))
            {
                return NotFound();
            }

            CodigoPostal codigoPostalModel = codigoPostal.DtoToCodigoPostalModel();

            _context.Entry(codigoPostalModel).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CodigoPostalExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/CodigoPostals
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<CodigoPostal>> PostCodigoPostal(CodigoPostalDTO codigoPostal)
        {
            CodigoPostal codigoPostalModel = codigoPostal.DtoToCodigoPostalModel();

            _context.CodigoPostals.Add(codigoPostalModel);

            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCodigoPostal", new { id = codigoPostal.IdCodigoPostal }, codigoPostal);
        }

        // DELETE: api/CodigoPostals/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCodigoPostal(string id)
        {
            var codigoPostal = await _context.CodigoPostals.FindAsync(id);
            if (codigoPostal == null)
            {
                return NotFound();
            }

            _context.CodigoPostals.Remove(codigoPostal);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CodigoPostalExists(string id)
        {
            return _context.CodigoPostals.Any(e => e.IdCodigoPostal == id);
        }
    }
}
