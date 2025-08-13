import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DeleteTipoUtilizadorComponent } from './delete-tipo-utilizador.component';

describe('DeleteTipoUtilizadorComponent', () => {
  let component: DeleteTipoUtilizadorComponent;
  let fixture: ComponentFixture<DeleteTipoUtilizadorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [DeleteTipoUtilizadorComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(DeleteTipoUtilizadorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
