import { TestBed } from '@angular/core/testing';

import { TipoUtilizadorService } from './tipo-utilizador.service';

describe('TipoUtilizadorService', () => {
  let service: TipoUtilizadorService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipoUtilizadorService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
